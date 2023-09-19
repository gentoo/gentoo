# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain-autoconf.eclass
# @MAINTAINER:
# <base-system@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common code for sys-devel/autoconf ebuilds
# @DESCRIPTION:
# This eclass contains the common phase functions migrated from
# sys-devel/autoconf eblits.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TOOLCHAIN_AUTOCONF_ECLASS} ]]; then
_TOOLCHAIN_AUTOCONF_ECLASS=1

# @ECLASS_VARIABLE: TC_AUTOCONF_BREAK_INFOS
# @DESCRIPTION:
# Enables slotting logic on the installed info pages.  This includes
# mangling the pages in order to include a version number.  Empty by
# default, and only exists for old ebuild revisions to use.  Do not set
# in new ebuilds.  Set to a non-empty value to enable.
# @DEPRECATED: none
: "${TC_AUTOCONF_BREAK_INFOS:=}"

# @ECLASS_VARIABLE: TC_AUTOCONF_INFOPATH
# @DESCRIPTION:
# Where to install info files if not slotting.
TC_AUTOCONF_INFOPATH="${EPREFIX}/usr/share/autoconf-${PV}/info"

toolchain-autoconf_src_prepare() {
	find -name Makefile.in -exec sed -i '/^pkgdatadir/s:$:-@VERSION@:' {} + || die
	default
}

toolchain-autoconf_src_configure() {
	# Disable Emacs in the build system since it is in a separate package.
	export EMACS=no
	local myconf=(
		--program-suffix="-${PV}"
	)
	if [[ -z "${TC_AUTOCONF_BREAK_INFOS}" && "${SLOT}" != 0 ]]; then
		myconf+=(
			--infodir="${TC_AUTOCONF_INFOPATH}"
		)
	fi
	econf "${myconf[@]}" || die
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
	if [[ -n "${TC_AUTOCONF_BREAK_INFOS}" ]]; then
		slot_info_pages
	else
		rm -f dir || die

		local major="$(ver_cut 1)"
		local minor="$(ver_cut 2)"
		local idx="$((99999-(major*1000+minor)))"
		newenvd - "06autoconf${idx}" <<-EOF
		INFOPATH="${TC_AUTOCONF_INFOPATH}"
		EOF

		pushd "${D}/${TC_AUTOCONF_INFOPATH}" >/dev/null || die
		for f in *.info*; do
			# Install convenience aliases for versioned Autoconf pages.
			ln -s "$f" "${f/./-${PV}.}" || die
		done
		popd >/dev/null || die
	fi
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_install
