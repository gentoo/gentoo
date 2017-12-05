# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain-autoconf.eclass
# @MAINTAINER:
# <base-system@gentoo.org>
# @BLURB: Common code for sys-devel/autoconf ebuilds
# @DESCRIPTION:
# This eclass contains the common phase functions migrated from
# sys-devel/autoconf eblits.

if [[ -z ${_TOOLCHAIN_AUTOCONF_ECLASS} ]]; then

inherit eutils

EXPORT_FUNCTIONS src_prepare src_configure src_install

toolchain-autoconf_src_prepare() {
	find -name Makefile.in -exec sed -i '/^pkgdatadir/s:$:-@VERSION@:' {} + || die

	[[ ${#PATCHES[@]} -gt 0 ]] && epatch "${PATCHES[@]}"
}

toolchain-autoconf_src_configure() {
	# Disable Emacs in the build system since it is in a separate package.
	export EMACS=no
	econf --program-suffix="-${PV}" || die
	# econf updates config.{sub,guess} which forces the manpages
	# to be regenerated which we dont want to do #146621
	touch man/*.1
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	[[ ${SLOT} == "0" ]] && return

	pushd "${ED}"/usr/share/info >/dev/null || die
	rm -f dir || die

	# Rewrite all the references to other pages.
	# before: * aclocal-invocation: (automake)aclocal Invocation.   Generating aclocal.m4.
	# after:  * aclocal-invocation v1.13: (automake-1.13)aclocal Invocation.   Generating aclocal.m4.
	local p pages=( *.info ) args=()
	for p in "${pages[@]/%.info}" ; do
		args+=(
			-e "/START-INFO-DIR-ENTRY/,/END-INFO-DIR-ENTRY/s|: (${p})| v${SLOT}&|"
			-e "s:(${p}):(${p}-${SLOT}):g"
		)
	done
	sed -i "${args[@]}" * || die

	# Rewrite all the file references, and rename them in the process.
	local f d
	for f in * ; do
		d=${f/.info/-${SLOT}.info}
		mv "${f}" "${d}" || die
		sed -i -e "s:${f}:${d}:g" * || die
	done

	popd >/dev/null || die
}

toolchain-autoconf_src_install() {
	default
	slot_info_pages
}

_TOOLCHAIN_AUTOCONF_ECLASS=1
fi
