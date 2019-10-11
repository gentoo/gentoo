# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilities for users of Gentoo Prefix"
HOMEPAGE="https://prefix.gentoo.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"

[[ ${PV} == 9999 ]] ||
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

DEPEND="
	!app-portage/prefix-chain-setup
	!sys-apps/prefix-chain-utils
"
BDEPEND="${DEPEND}
	>sys-apps/portage-2.3.62
"
# In prefix-stack, these dependencies actually are the @system set,
# as we rely on the base prefix anyway for package management,
# which should have a proper @system set.
# See als: pkg_preinst
RDEPEND="${DEPEND}
	prefix-stack? (
		>=sys-apps/baselayout-prefix-2.6
		sys-apps/gentoo-functions
		app-portage/elt-patches
		sys-devel/gnuconfig
		sys-devel/gcc-config
	)
"

S="${WORKDIR}"

my_unpack() {
	local infile=$1
	local outfile=${2:-${infile}}
	ebegin "extracting ${outfile}"
	sed -ne "/^: ${infile} /,/EOIN/{/EOIN/d;p}" "${EBUILD}" \
		> "${outfile}" || die "Failed to unpack ${outfile}"
	eend $?
}

src_unpack() {
	if use prefix-stack ; then
		my_unpack prefix-stack.bash_login
		my_unpack prefix-stack.bashrc
		my_unpack prefix-stack.envd.99stack
		my_unpack prefix-stack-ccwrap
		local editor pager
		for editor in "${EDITOR}" {"${EPREFIX}","${BROOT}"}/bin/nano
		do
			[[ -x ${editor} ]] || continue
		done
		for pager in "${PAGER}" {"${EPREFIX}","${BROOT}"}/usr/bin/less
		do
			[[ -x ${pager} ]] || continue
		done
		printf '%s\n' "EDITOR=\"${editor}\"" "PAGER=\"${pager}\"" > 000fallback
	else
		my_unpack prefix-stack-setup
	fi
	my_unpack startprefix
}

my_prefixify() {
	local ebash eenv
	if use prefix-stack ; then
		ebash="${BROOT}/bin/bash"
		eenv="${BROOT}/usr/bin/env"
	else
		ebash="${EPREFIX}/bin/bash"
		eenv="${EPREFIX}/usr/bin/env"
	fi

	# the @=@ prevents repoman from believing we set readonly vars
	sed -e "s,@GENTOO_PORTAGE_BPREFIX@,${BROOT},g" \
		-e "s,@GENTOO_PORTAGE_EPREFIX@,${EPREFIX},g" \
		-e "s,@GENTOO_PORTAGE_CHOST@,${CHOST},g" \
		-e "s,@GENTOO_PORTAGE_EBASH@,${ebash},g" \
		-e "s,@GENTOO_PORTAGE_EENV@,${eenv},g" \
		-e "s,@=@,=,g" \
		-i "$@" || die
}

src_configure() {
	# do not eprefixify during unpack, to allow userpatches to apply
	my_prefixify *
}

src_install-prefix-stack-ccwrap() {
	# install toolchain wrapper.
	local wrapperdir=/usr/${CHOST}/gcc-bin/${CHOST}-${PN}/${PV}
	local wrappercfg=${CHOST}-${P}

	exeinto $wrapperdir
	doexe prefix-stack-ccwrap

	local cc
	for cc in \
		gcc \
		g++ \
		cpp \
		c++ \
		windres \
	; do
		dosym prefix-stack-ccwrap $wrapperdir/${CHOST}-${cc}
		dosym ${CHOST}-${cc} $wrapperdir/${cc}
	done

	# LDPATH is required to keep gcc-config happy :(
	cat > ./${wrappercfg} <<-EOF
		GCC_PATH="${EPREFIX}$wrapperdir"
		LDPATH="${EPREFIX}$wrapperdir"
		EOF

	insinto /etc/env.d/gcc
	doins ./${wrappercfg}
}

src_install() {
	if use prefix-stack; then
		src_install-prefix-stack-ccwrap
		insinto /etc
		doins prefix-stack.bash_login
		insinto /etc/bash
		newins prefix-stack.bashrc bashrc
		newenvd prefix-stack.envd.99stack 99stack
		doenvd 000fallback
	else
		dobin prefix-stack-setup
	fi
	exeinto /
	doexe startprefix
}

pkg_preinst() {
	use prefix-stack || return 0
	ebegin "Purging @system package set for prefix stack"
	# In prefix stack we empty out the @system set defined via make.profile,
	# as we may be using some normal profile, but that @system set applies
	# to the base prefix only.
	# Instead, we only put ourselve into the @system set, and have additional
	# @system packages in our RDEPEND.
	my_lsprofile() {
		(
			cd -P "${1:-.}" || exit 1
			[[ -r ./parent ]] &&
				for p in $(<parent)
				do
					my_lsprofile "${p}" || exit 1
				done
			pwd -P
		)
	}
	local systemset="/etc/portage/profile/packages"
	dodir "${systemset%/*}"
	[[ -s ${EROOT}${systemset} ]] &&
		grep -v "# maintained by ${PN}" \
			"${EROOT}${systemset}" \
			> "${ED}${systemset}"
	local p
	for p in $(my_lsprofile "${EPREFIX}"/etc/portage/make.profile)
	do
		[[ -s ${p}/${systemset##*/} ]] || continue
		awk '/^[ \t]*[^-#]/{print "-" $1 " # maintained by '"${PN}-${PVR}"'"}' \
			< "${p}"/packages || die
	done | sort -u >> "${ED}${systemset}"
	[[ ${PIPESTATUS[@]} == "0 0" ]] || die "failed to collect for ${systemset}"
	echo "*${CATEGORY}/${PN} # maintained by ${PN}-${PVR}" >> "${ED}${systemset}" || die
	eend $?
}

return 0

: startprefix <<'EOIN'
#!@GENTOO_PORTAGE_EBASH@
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Fabian Groffen <grobian@gentoo.org> -- 2007-03-10
# Enters the prefix environment by starting a login shell from the
# prefix.  The SHELL environment variable is elevated in order to make
# applications that start login shells to work, such as `screen`.

# if you come from a substantially polluted environment (another
# Prefix), a cleanup as follows resolves most oddities I've ever seen:
# env -i HOME=$HOME TERM=$TERM USER=$USER $SHELL -l
# hence this script starts the Prefix shell like this

if [[ ${SHELL#@GENTOO_PORTAGE_EPREFIX@} != ${SHELL} ]]
then
	echo "You appear to be in prefix already (SHELL=${SHELL})" > /dev/stderr
	exit -1
elif [[ ${SHELL#@GENTOO_PORTAGE_BPREFIX@} != ${SHELL} ]] &&
	 [[ ${EPREFIX-unset} == '@GENTOO_PORTAGE_EPREFIX@' ]]
then
	echo "You appear to be in stacked prefix already (EPREFIX=${EPREFIX})" > /dev/stderr
	exit -1
fi

# What is our prefix?
EPREFIX@=@'@GENTOO_PORTAGE_EPREFIX@'
BPREFIX@=@'@GENTOO_PORTAGE_BPREFIX@'

# not all systems have the same location for shells, however what it
# boils down to, is that we need to know what the shell is, and then we
# can find it in the bin dir of our prefix
for SHELL in \
	"${EPREFIX}/bin/${SHELL##*/}" \
	"${BPREFIX}/bin/${SHELL##*/}" \
	${SHELL##*/}
do
	[[ ${SHELL} == */* && -x ${SHELL} ]] && break
done

# check if the shell exists
if [[ ${SHELL} != */* ]]
then
	echo "Failed to find the Prefix shell, this is probably" > /dev/stderr
	echo "because you didn't emerge the shell ${SHELL}" > /dev/stderr
	exit 1
fi

# set the prefix shell in the environment
export SHELL

# give a small notice
echo "Entering Gentoo Prefix ${EPREFIX}"
# start the login shell, clean the entire environment but what's needed
RETAIN="HOME=$HOME TERM=$TERM USER=$USER SHELL=$SHELL"
# PROFILEREAD is necessary on SUSE not to wipe the env on shell start
[[ -n ${PROFILEREAD} ]] && RETAIN+=" PROFILEREAD=$PROFILEREAD"
# ssh-agent is handy to keep, of if set, inherit it
[[ -n ${SSH_AUTH_SOCK} ]] && RETAIN+=" SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
# if we're on some X terminal, makes sense to inherit that too
[[ -n ${DISPLAY} ]] && RETAIN+=" DISPLAY=$DISPLAY"
# do it!
if [[ ${SHELL#${EPREFIX}} != ${SHELL} ]] ; then
	'@GENTOO_PORTAGE_EENV@' -i $RETAIN $SHELL -l
elif [[ ' bash ' == *" ${SHELL##*/} "* ]] ; then
	# shell coming from different prefix would load it's own
	# etc/profile upon -l, so we have to override
	'@GENTOO_PORTAGE_EENV@' -i ${RETAIN} "${SHELL}" --rcfile "${EPREFIX}"/etc/prefix-stack.bash_login -i
else
	echo "Only bash is supported with stacked Prefix (you have ${SHELL##*/}), sorry!" > /dev/stderr
	exit 1
fi
# and leave a message when we exit... the shell might return non-zero
# without having real problems, so don't send alarming messages about
# that
echo "Leaving Gentoo Prefix with exit status $?"
EOIN

: prefix-stack.bashrc <<'EOIN'
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# In stacked Prefix there is no bash installed, yet
# etc/bash/bashrc from base Prefix still is useful.
#

if [[ $- != *i* ]] ; then
	# Shell is non-interactive, bashrc does not apply
	return
fi

if [[ -r @GENTOO_PORTAGE_BPREFIX@/etc/bash/bashrc ]] ; then
	source '@GENTOO_PORTAGE_BPREFIX@/etc/bash/bashrc'
	# only if base Prefix does have an etc/bash/bashrc, we also
	# run bashrc snippets provided by packages in stacked Prefix
	for sh in '@GENTOO_PORTAGE_EPREFIX@'/etc/bash/bashrc.d/* ; do
		[[ -r ${sh} ]] && source "${sh}"
	done
	unset sh
else
	# etc/profile does expect etc/bash/bashrc to set PS1
	PS1='\u@\h \w \$ '
fi
EOIN

: prefix-stack.bash_login <<'EOIN'
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# In stacked Prefix there is no bash installed, so there is
# no bash able to load this Prefix' profile as login shell.
# Instead, you can specify this one as bash rcfile to mimic
# a bash login shell using this stacked Prefix profile.
#

if [[ -s '@GENTOO_PORTAGE_EPREFIX@/etc/profile' ]] ; then
	. '@GENTOO_PORTAGE_EPREFIX@/etc/profile'
fi
if [[ -s ~/.bash_profile ]] ; then
	. ~/.bash_profile
elif [[ -s ~/.bash_login ]] ; then
	. ~/.bash_login
elif [[ -s ~/.profile ]] ; then
	. ~/.profile
fi
EOIN

: prefix-stack.envd.99stack <<'EOIN'
PKG_CONFIG_PATH@=@"@GENTOO_PORTAGE_EPREFIX@/usr/lib/pkgconfig:@GENTOO_PORTAGE_EPREFIX@/usr/share/pkgconfig"
PORTAGE_CONFIGROOT@=@"@GENTOO_PORTAGE_EPREFIX@"
EPREFIX@=@"@GENTOO_PORTAGE_EPREFIX@"
EOIN

: prefix-stack-setup <<'EOIN'
#!@GENTOO_PORTAGE_EPREFIX@/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

PARENT_EPREFIX="@GENTOO_PORTAGE_EPREFIX@"
PARENT_CHOST="@GENTOO_PORTAGE_CHOST@"
CHILD_EPREFIX=
CHILD_PROFILE=
CHILD_CHOST=

#
# get ourselfs the functions.sh script for ebegin/eend/etc.
#
for f in \
	/lib/gentoo/functions.sh \
	/etc/init.d/functions.sh \
	/sbin/functions.sh \
; do
	if [[ -r ${PARENT_EPREFIX}${f} ]] ; then
		. "${PARENT_EPREFIX}${f}"
		f=found
		break
	fi
done

if [[ ${f} != found ]] ; then
	echo "Cannot find Gentoo functions, aborting." >&2
	exit 1
fi

for arg in "$@"; do
	case "${arg}" in
	--eprefix=*) CHILD_EPREFIX="${arg#--eprefix=}" ;;
	--profile=*) CHILD_PROFILE="${arg#--profile=}" ;;
	--chost=*)   CHILD_CHOST="${arg#--chost=}" ;;

	--help)
		einfo "$0 usage:"
		einfo "  --eprefix=[PATH]       Path to new EPREFIX to create stacked to the prefix"
		einfo "                         where this script is installed (${PARENT_EPREFIX})"
		einfo "  --profile=[PATH]       The absolute path to the profile to use. This path"
		einfo "                         must point to a directory within ${PARENT_EPREFIX}"
		einfo "  --chost=[CHOST]        The CHOST to use for the new EPREFIX, required if"
		einfo "                         the profile does not set CHOST, or to override."
		exit 0
		;;
	esac
done

#
# sanity check of given values
#

test -n "${CHILD_EPREFIX}" || { eerror "no eprefix argument given"; exit 1; }
test -d "${CHILD_EPREFIX}" && { eerror "${CHILD_EPREFIX} already exists"; exit 1; }
test -n "${CHILD_PROFILE}" || { eerror "no profile argument given"; exit 1; }
test -d "${CHILD_PROFILE}" || { eerror "${CHILD_PROFILE} does not exist"; exit 1; }

if [[ -z ${CHILD_CHOST} ]]
then
	my_lsprofile() {
		(
			cd -P "${1:-.}" || exit 1
			[[ -r ./parent ]] &&
				for p in $(<parent)
				do
					my_lsprofile "${p}" || exit 1
				done
			pwd -P
		)
	}

	for profile in $(my_lsprofile "${CHILD_PROFILE}") missing
	do
		if [[ ${profile} == missing ]]
		then
		  eerror "profile does not set CHOST, need --chost argument"
		  exit 1
		fi
		[[ -s "${profile}/make.defaults" ]] || continue
		grep -q '^[ 	]*CHOST@=@' "${profile}/make.defaults" && break
	done
fi

einfo "creating stacked prefix ${CHILD_EPREFIX}"

#
# functions needed below.
#
eend_exit() {
	eend $1
	[[ $1 != 0 ]] && exit 1
}

#
# create the directories required to bootstrap the least.
#
ebegin "creating directory structure"
(
	set -e
	mkdir -p "${CHILD_EPREFIX}"/etc/portage/profile/use.mask
	mkdir -p "${CHILD_EPREFIX}"/etc/portage/profile/use.force
	mkdir -p "${CHILD_EPREFIX}"/etc/portage/env
	mkdir -p "${CHILD_EPREFIX}"/etc/portage/package.env
	ln -s "${PARENT_EPREFIX}"/etc/portage/repos.conf "${CHILD_EPREFIX}"/etc/portage/repos.conf
)
eend_exit $?

#
# create a make.conf and set PORTDIR and PORTAGE_TMPDIR
#
ebegin "creating make.conf"
(
	set -e
	echo "#"
	echo "# The following values where taken from the parent prefix's"
	echo "# environment. Feel free to adopt them as you like."
	echo "#"
	echo "CFLAGS=\"$(portageq envvar CFLAGS)\""
	echo "CXXFLAGS=\"$(portageq envvar CXXFLAGS)\""
	echo "MAKEOPTS=\"$(portageq envvar MAKEOPTS)\""
	niceness=$(portageq envvar PORTAGE_NICENESS || true)
	[[ -n ${niceness} ]] &&
		echo "PORTAGE_NICENESS=\"${niceness}\""
	echo
	echo "# Mirrors from parent prefix."
	echo "GENTOO_MIRRORS=\"$(portageq envvar GENTOO_MIRRORS || true)\""
	echo
	echo "# Below comes the prefix-stack setup. Only change things"
	echo "# if you know exactly what you are doing!"
	echo "EPREFIX=\"${CHILD_EPREFIX}\""
	echo "PORTAGE_OVERRIDE_EPREFIX=\"${PARENT_EPREFIX}\""
	echo "BROOT=\"${PARENT_EPREFIX}\""
	# Since EAPI 7 there is BDEPEND, which is DEPEND in EAPI up to 6.
	# We do not want to pull DEPEND from EAPI <= 6, but RDEPEND only.
	echo "EMERGE_DEFAULT_OPTS=\"--root-deps=rdeps\""
	if [[ -n ${CHILD_CHOST} ]] ; then
		echo "CHOST=\"${CHILD_CHOST}\""
	fi
) > "${CHILD_EPREFIX}"/etc/portage/make.conf
eend_exit $?

ebegin "creating use.mask/prefix-stack"
printf -- '-%s\n' prefix{,-guest,-stack} > "${CHILD_EPREFIX}"/etc/portage/profile/use.mask/prefix-stack
eend_exit $?

ebegin "creating use.force/prefix-stack"
printf -- '%s\n' prefix{,-guest,-stack} > "${CHILD_EPREFIX}"/etc/portage/profile/use.force/prefix-stack
eend_exit $?

ebegin "creating env/host-cc.conf"
cat > "${CHILD_EPREFIX}"/etc/portage/env/host-cc.conf <<-EOM
	CC=${PARENT_CHOST}-gcc
	CXX=${PARENT_CHOST}-g++
	EOM
eend_exit $?

ebegin "creating package.env/prefix-stack"
cat > "${CHILD_EPREFIX}"/etc/portage/package.env/prefix-stack <<-'EOM'
	# merge with the parent's chost. this forces the use of the parent
	# compiler, which generally would be illegal - this is an exception.
	# This is required for example on winnt, because the wrapper has to
	# be able to use/resolve symlinks, etc. native winnt binaries miss
	# that ability, but cygwin binaries don't.
	sys-devel/gcc-config host-cc.conf
	sys-apps/gentoo-functions host-cc.conf
	EOM
eend_exit $?

#
# create the make.profile symlinks.
#
ebegin "creating make.profile"
(
	ln -s "${CHILD_PROFILE}" "${CHILD_EPREFIX}/etc/portage/make.profile"
)
eend_exit $?

#
# adjust permissions of generated files.
#
ebegin "adjusting permissions"
(
	set -e
	chmod 644 "${CHILD_EPREFIX}"/etc/portage/make.conf
	chmod 644 "${CHILD_EPREFIX}"/etc/portage/env/host-cc.conf
	chmod 644 "${CHILD_EPREFIX}"/etc/portage/package.env/prefix-stack
)
eend_exit $?

#
# now merge some basics.
#
ebegin "installing required basic packages"
(
	set -e
	export PORTAGE_CONFIGROOT@=@"${CHILD_EPREFIX}"
	export EPREFIX@=@"${CHILD_EPREFIX}"
	export PORTAGE_OVERRIDE_EPREFIX@=@"${PARENT_EPREFIX}"

	# let baselayout create the directories
	USE@=@"${USE} build" \
	emerge --verbose --nodeps --oneshot \
		'>=baselayout-prefix-2.6'

	# In prefix-stack, app-portage/prefix-toolkit does
	# install/update an etc/portage/profile/packages file,
	# removing all @system packages from current make.profile,
	# and adding itself to @system set instead.
	emerge --verbose --nodeps --oneshot \
		app-portage/prefix-toolkit

	# In prefix-stack, prefix-toolkit does have an RDEPEND on them,
	# to hold them in the @system set.
	emerge --verbose --nodeps --oneshot \
		sys-apps/gentoo-functions \
		app-portage/elt-patches \
		sys-devel/gnuconfig \
		sys-devel/gcc-config

	# select the stack wrapper profile from gcc-config
	env -i PORTAGE_CONFIGROOT="${CHILD_EPREFIX}" \
		"$(type -P bash)" "${CHILD_EPREFIX}"/usr/bin/gcc-config 1
)
eend_exit $?

#
# wow, all ok :)
#
ewarn
ewarn "all done. don't forget to tune ${CHILD_EPREFIX}/etc/portage/make.conf."
ewarn "to enter the new prefix, run \"${CHILD_EPREFIX}/startprefix\"."
ewarn
EOIN

: prefix-stack-ccwrap <<'EOIN'
#!@GENTOO_PORTAGE_BPREFIX@/bin/bash

if [ -r /cygdrive/. ]; then
	winpath2unix() { cygpath -u "$1"; }
	unixpath2win() { cygpath -w "$1"; }
fi

myself=${0##*/} # basename $0
link_dirs=()
opts=()
chost="@GENTOO_PORTAGE_CHOST@"
prefix="@GENTOO_PORTAGE_EPREFIX@"
absprefix=${prefix}
if [[ ${chost} == *"-winnt"* ]]; then
	# we may get called from windows binary, like pkgdata in dev-libs/icu
	# in this case, PATH elements get the "/dev/fs/C/WINDOWS/SUA" prefix
	absprefix=$(winpath2unix "$(unixpath2win "${absprefix}")")
fi
[[ ${myself} == *windres* ]] && mode=compile || mode=link
orig_args=("$@")

for opt in "$@"
do
	case "$opt" in
	-L)
		link_dirs=("${link_dirs[@]}" "-L$1")
		shift
		;;
	-L*)
		link_dirs=("${link_dirs[@]}" "${opt}")
		;;
	*)
		case "${opt}" in
		-v)
			# -v done right: only use mode version if -v is the _only_
			# argument on the command line.
			[[ ${#orig_args[@]} -gt 1 ]] || mode=version
			;;
		--version)	mode=version ;;
		-c|-E|-S)	mode=compile ;;
		-print-search-dirs) mode=dirs ;;
		esac
		opts=("${opts[@]}" "${opt}")
		;;
	esac
done

# remove any path to current prefix, need base prefix only
new_path=
save_ifs=$IFS
IFS=':'
for p in $PATH
do
	IFS=$save_ifs
	[[ ${p#${absprefix}} != "${p}" ]] && continue
	if [[ -z "${new_path}" ]]; then
		new_path="${p}"
	else
		new_path="${new_path}:${p}"
	fi
done
IFS=$save_ifs

PATH=${new_path}

pfx_comp=("-I${prefix}/include" "-I${prefix}/usr/include")
pfx_link=("-L${prefix}/usr/lib" "-L${prefix}/lib")
# binutils-config's ldwrapper understands '-R' for aix and hpux too.
pfx_link_r=("-Wl,-R,${prefix}/lib" "-Wl,-R,${prefix}/usr/lib")
case "${chost}" in
*-winnt*)
	# parity (winnt) understands -rpath only ...
	pfx_link_r=("-Wl,-rpath,${prefix}/lib" "-Wl,-rpath,${prefix}/usr/lib")
	;;
*-linux*)
	# With gcc, -isystem would avoid warning messages in installed headers,
	# but that breaks with AIX host headers.
	pfx_comp=("-isystem" "${prefix}/include" "-isystem" "${prefix}/usr/include")
	;;
esac

# ensure we run the right chost program in base prefix
[[ ${myself} == *-*-*-* ]] || myself=${chost}-${myself#${chost}-}

case "$mode" in
link)    exec "${myself}" "${link_dirs[@]}" "${pfx_link[@]}" "${opts[@]}" "${pfx_comp[@]}" "${pfx_link_r[@]}" ;;
compile) exec "${myself}" "${link_dirs[@]}" "${opts[@]}" "${pfx_comp[@]}" ;;
version) exec "${myself}" "${orig_args[@]}" ;;
dirs)
	"${myself}" "${orig_args[@]}" | while read line; do
		if [[ "${line}" == "libraries: ="* ]]; then
			echo "libraries: =${prefix}/usr/lib:${prefix}/lib:${line#"libraries: ="}"
		else
			echo "${line}"
		fi
	done
	;;
*)			echo "cannot infer ${myself}'s mode from comamnd line arguments"; exit 1 ;;
esac
EOIN
