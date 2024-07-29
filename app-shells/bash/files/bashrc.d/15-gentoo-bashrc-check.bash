# /etc/bash/bashrc.d/15-gentoo-bashrc-check.bash

# Some users have ~/.bashrc as a copy of ${FILESDIR}/bashrc which either matches
# exactly or is only trivially modified. Such is an improper state of affairs
# and results in the bashrc.d drop-ins being sourced twice. Warn them that they
# should use the skeleton file instead. This drop-in should be removed no sooner
# than one year from the date of its introduction.

if [[ -e ${TMPDIR:-/tmp}/.gentoo-bashrc-check-${EUID} || ! -f ~/.bashrc ]]; then
	return
fi

{
	if grep -qxF 'for sh in /etc/bash/bashrc.d/* ; do' -- ~/.bashrc; then
		cat >&3 <<'EOF'
WARNING! Your ~/.bashrc file is based on an old copy of /etc/bash/bashrc, which
is not intended for use within a home directory. Please either delete ~/.bashrc
or replace it with a copy of /etc/skel/.bashrc before optionally customizing it
further. Neglecting to do so may result in bash behaving unexpectedly.

EOF
	fi
	touch -- "${TMPDIR:-/tmp}/.gentoo-bashrc-check-${EUID}"
} 3>&2 2>/dev/null
