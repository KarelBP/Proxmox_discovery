#!/usr/bin/env bash
set -euo pipefail
export PATH="/usr/sbin:/sbin:/usr/bin:/bin"

USER="disco"
SUDOERS_FILE="/etc/sudoers.d/disco"
TMPFILE="$(mktemp)"

#1 Build sudoers file
{
  echo "# Generated on $(date -u)"
  echo "# Allow $USER to run selected diagnostic commands as root without password"
  
  [ -x "$(type -P pvesh)" ]  && echo "Defaults!$(type -P pvesh) env_reset, !env_keep"
  
  echo "$USER ALL=(root) NOPASSWD:\\"

  [ -x "$(type -P dmidecode)" ]  && echo "    $(type -P dmidecode), \\"
  [ -x "$(type -P fdisk)" ]      && echo "    $(type -P fdisk) -l, \\"
  [ -x "$(type -P multipath)" ]  && echo "    $(type -P multipath) -ll, \\"
  [ -x "$(type -P dmsetup)" ]    && echo "    $(type -P dmsetup) table, \\"
  [ -x "$(type -P dmsetup)" ]    && echo "    $(type -P dmsetup) table *, \\"
  [ -x "$(type -P dmsetup)" ]    && echo "    $(type -P dmsetup) ls, \\"
  [ -x "$(type -P ls)" ]         && echo "    $(type -P ls), \\"
  [ -x "$(type -P lsof)" ]       && echo "    $(type -P lsof), \\"
  [ -x "$(type -P pvesh)" ]      && echo "    $(type -P pvesh) get *, \\"

} >"$TMPFILE"

# Remove trailing comma/backslash from last line
sed -i '${s/, \\$//}' "$TMPFILE"

#2 Validate and install sudoers file
if visudo -c -f "$TMPFILE" >/dev/null; then
    install -m 0440 -o root -g root "$TMPFILE" "$SUDOERS_FILE"
    echo "OK: Installed $SUDOERS_FILE"
else
    echo "ERROR: visudo validation failed — sudoers file not installed"
    echo "Check syntax manually with: sudo visudo -f $TMPFILE"
    exit 1
fi
rm -f "$TMPFILE"

#3 Add user to libvirt group if group exists
if getent group libvirt >/dev/null; then
    if id -nG "$USER" | grep -qw libvirt; then
        echo "INFO: User $USER is already in libvirt group"
    else
        usermod -aG libvirt "$USER"
        echo "OK: Added $USER to libvirt group (will take effect after next login)"
    fi
else
    echo "WARN: Group 'libvirt' does not exist — skipping group addition"
fi
