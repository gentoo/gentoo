# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/timezone-data/timezone-data-2015c-r1.ebuild,v 1.1 2015/04/14 16:19:36 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs flag-o-matic

code_ver=${PV}
data_ver=${PV}
DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="http://www.iana.org/time-zones http://www.twinsun.com/tz/tz-link.htm"
SRC_URI="http://www.iana.org/time-zones/repository/releases/tzdata${data_ver}.tar.gz
	http://www.iana.org/time-zones/repository/releases/tzcode${code_ver}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="nls leaps_timezone elibc_FreeBSD elibc_glibc"

RDEPEND="!sys-libs/glibc[vanilla(+)]"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2015c-makefile.patch
	tc-is-cross-compiler && cp -pR "${S}" "${S}"-native
}

_emake() {
	emake \
		TOPDIR="${EPREFIX}/usr" \
		REDO=$(usex leaps_timezone posix_right posix_only) \
		"$@"
}

src_compile() {
	local LDLIBS
	tc-export CC
	if use elibc_FreeBSD || use elibc_Darwin ; then
		append-cppflags -DSTD_INSPIRED #138251
	fi
	export NLS=$(usex nls 1 0)
	if use nls && ! use elibc_glibc ; then
		LDLIBS+=" -lintl" #154181
	fi
	# TOPDIR is used in some utils when compiling.
	_emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		CFLAGS="${CFLAGS} -std=gnu99" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="${LDLIBS}"
	if tc-is-cross-compiler ; then
		_emake -C "${S}"-native \
			CC="$(tc-getBUILD_CC)" \
			CFLAGS="${BUILD_CFLAGS}" \
			CPPFLAGS="${BUILD_CPPFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}" \
			LDLIBS="${LDLIBS}" \
			zic
	fi
}

src_install() {
	local zic=""
	tc-is-cross-compiler && zic="zic=${S}-native/zic"
	_emake install ${zic} DESTDIR="${D}"
	dodoc CONTRIBUTING README NEWS Theory
	dohtml *.htm
}

get_TIMEZONE() {
	local tz src="${EROOT}etc/timezone"
	if [[ -e ${src} ]] ; then
		tz=$(sed -e 's:#.*::' -e 's:[[:space:]]*::g' -e '/^$/d' "${src}")
	else
		tz="FOOKABLOIE"
	fi
	[[ -z ${tz} ]] && return 1 || echo "${tz}"
}

pkg_preinst() {
	local tz=$(get_TIMEZONE)
	if [[ ${tz} == right/* || ${tz} == posix/* ]] ; then
		eerror "The right & posix subdirs are no longer installed as subdirs -- they have been"
		eerror "relocated to match upstream paths as sibling paths.  Further, posix/xxx is the"
		eerror "same as xxx, so you should simply drop the posix/ prefix.  You also should not"
		eerror "be using right/xxx for the system timezone as it breaks programs."
		die "Please fix your timezone setting"
	fi

	# Trim the symlink by hand to avoid portage's automatic protection checks.
	rm -f "${EROOT}"/usr/share/zoneinfo/posix

	if has_version "<=${CATEGORY}/${PN}-2015c" ; then
		elog "Support for accessing posix/ and right/ directly has been dropped to match"
		elog "upstream.  There is no need to set TZ=posix/xxx as it is the same as TZ=xxx."
		elog "For TZ=right/, you can use TZ=../zoneinfo-leaps/xxx instead.  See this post"
		elog "for details: https://mm.icann.org/pipermail/tz/2015-February/022024.html"
	fi
}

pkg_config() {
	# make sure the /etc/localtime file does not get stale #127899
	local tz src="${EROOT}etc/timezone" etc_lt="${EROOT}etc/localtime"

	tz=$(get_TIMEZONE) || return 0
	if [[ ${tz} == "FOOKABLOIE" ]] ; then
		elog "You do not have TIMEZONE set in ${src}."

		if [[ ! -e ${etc_lt} ]] ; then
			# if /etc/localtime is a symlink somewhere, assume they
			# know what they're doing and they're managing it themselves
			if [[ ! -L ${etc_lt} ]] ; then
				cp -f "${EROOT}"/usr/share/zoneinfo/Factory "${etc_lt}"
				elog "Setting ${etc_lt} to Factory."
			else
				elog "Assuming your ${etc_lt} symlink is what you want; skipping update."
			fi
		else
			elog "Skipping auto-update of ${etc_lt}."
		fi
		return 0
	fi

	if [[ ! -e ${EROOT}/usr/share/zoneinfo/${tz} ]] ; then
		elog "You have an invalid TIMEZONE setting in ${src}"
		elog "Your ${etc_lt} has been reset to Factory; enjoy!"
		tz="Factory"
	fi
	if [[ -L ${etc_lt} ]]; then
		einfo "Skipping symlinked ${etc_lt}"
	else
		einfo "Updating ${etc_lt} with ${EROOT}usr/share/zoneinfo/${tz}"
		cp -f "${EROOT}"/usr/share/zoneinfo/"${tz}" "${etc_lt}"
	fi
}

pkg_postinst() {
	pkg_config
}
