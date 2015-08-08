# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs flag-o-matic

code_ver=${PV}
data_ver=${PV}
DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="http://www.iana.org/time-zones http://www.twinsun.com/tz/tz-link.htm"
SRC_URI="http://www.iana.org/time-zones/repository/releases/tzdata${data_ver}.tar.gz
	http://www.iana.org/time-zones/repository/releases/tzcode${code_ver}.tar.gz
	ftp://munnari.oz.au/pub/oldtz/tzdata${data_ver}.tar.gz
	ftp://munnari.oz.au/pub/oldtz/tzcode${data_ver}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="nls elibc_FreeBSD elibc_glibc"

RDEPEND="!<sys-libs/glibc-2.3.5"

S=${WORKDIR}

pkg_setup() {
	# Deal with the case where older timezone-data installed a
	# dir here, but newer one installs symlinks.  Portage will
	# barf when you try to transition file types.
	if cd "${EROOT}"/usr/share/zoneinfo 2>/dev/null ; then
		if [[ -d posix ]] ; then
			rm -rf .gentoo-upgrade #487192
			mv posix .gentoo-upgrade || die
			ln -s .gentoo-upgrade posix || die
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2013h-makefile.patch
	tc-is-cross-compiler && cp -pR "${S}" "${S}"-native
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
	emake \
		TOPDIR="${EPREFIX}/usr" \
		CFLAGS="${CPPFLAGS} ${CFLAGS} -std=gnu99" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="${LDLIBS}" \
		|| die
	if tc-is-cross-compiler ; then
		emake -C "${S}"-native \
			CC=$(tc-getBUILD_CC) \
			CFLAGS="${BUILD_CFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}" \
			LDLIBS="${LDLIBS}" \
			zic || die
	fi
}

src_install() {
	local zic=""
	tc-is-cross-compiler && zic="zic=${S}-native/zic"
	emake install ${zic} DESTDIR="${ED}" || die
	dodoc README Theory
	dohtml *.htm
}

pkg_config() {
	# make sure the /etc/localtime file does not get stale #127899
	local tz src etc_lt="${EROOT}etc/localtime"

	if has_version '<sys-apps/baselayout-2' ; then
		src="${EROOT}etc/conf.d/clock"
		tz=$(unset TIMEZONE ; source "${src}" ; echo ${TIMEZONE-FOOKABLOIE})
	else
		src="${EROOT}etc/timezone"
		if [[ -e ${src} ]] ; then
			tz=$(sed -e 's:#.*::' -e 's:[[:space:]]*::g' -e '/^$/d' "${src}")
		else
			tz="FOOKABLOIE"
		fi
	fi
	[[ -z ${tz} ]] && return 0

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
	einfo "Updating ${etc_lt} with ${EROOT}usr/share/zoneinfo/${tz}"
	[[ -L ${etc_lt} ]] && rm -f "${etc_lt}"
	cp -f "${EROOT}"/usr/share/zoneinfo/"${tz}" "${etc_lt}"
}

pkg_postinst() {
	rm -rf "${EROOT}"/usr/share/zoneinfo/.gentoo-upgrade &
	pkg_config
	wait
}
