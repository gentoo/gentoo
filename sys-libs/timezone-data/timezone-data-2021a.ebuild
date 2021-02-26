# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs flag-o-matic

code_ver=${PV}
data_ver=${PV}
DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="https://www.iana.org/time-zones"
SRC_URI="https://www.iana.org/time-zones/repository/releases/tzdata${data_ver}.tar.gz
	https://www.iana.org/time-zones/repository/releases/tzcode${code_ver}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls leaps-timezone elibc_FreeBSD zic-slim"

DEPEND="nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	!sys-libs/glibc[vanilla(+)]"

S=${WORKDIR}

src_prepare() {
	default

	# check_web contacts validator.w3.org
	sed -i -e 's/check_tables check_web/check_tables/g' \
		Makefile || die "Failed to disable check_web"

	tc-is-cross-compiler && cp -pR "${S}" "${S}"-native
}

src_configure() {
	tc-export CC

	append-lfs-flags #471102

	if use elibc_FreeBSD || use elibc_Darwin ; then
		append-cppflags -DSTD_INSPIRED #138251
	fi

	append-cppflags -DHAVE_GETTEXT=$(usex nls 1 0) -DTZ_DOMAIN='\"libc\"'

	# Upstream default is 'slim', but it breaks quite a few programs
	# that parse /etc/localtime directly: bug# 747538.
	append-cppflags -DZIC_BLOAT_DEFAULT='\"'$(usex zic-slim slim fat)'\"'

	LDLIBS=""
	if use nls ; then
		# See if an external libintl is available. #154181 #578424
		local c="${T}/test"
		echo 'main(){}' > "${c}.c"
		if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} "${c}.c" -o "${c}" -lintl 2>/dev/null ; then
			LDLIBS+=" -lintl"
		fi
	fi
}

_emake() {
	emake \
		REDO=$(usex leaps-timezone posix_right posix_only) \
		TZDATA_TEXT= \
		TOPDIR="${EPREFIX}" \
		ZICDIR='$(TOPDIR)/usr/bin' \
		"$@"
}

src_compile() {
	_emake \
		AR="$(tc-getAR)" \
		cc="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		CFLAGS="${CFLAGS} -std=gnu99 ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="${LDLIBS}"
	if tc-is-cross-compiler ; then
		_emake -C "${S}"-native \
			AR="$(tc-getBUILD_AR)" \
			cc="$(tc-getBUILD_CC)" \
			RANLIB="$(tc-getBUILD_RANLIB)" \
			CFLAGS="${BUILD_CFLAGS} ${BUILD_CPPFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}" \
			LDLIBS="${LDLIBS}" \
			zic
	fi
}

src_test() {
	# VALIDATE_ENV is used for extended/web based tests.  Punt on them.
	emake check VALIDATE_ENV=true
}

src_install() {
	local zic=""
	tc-is-cross-compiler && zic="zic=${S}-native/zic"
	_emake install ${zic} DESTDIR="${D}" LIBDIR="/nukeit"
	rm -rf "${D}/nukeit" "${ED}/etc" || die

	insinto /usr/share/zoneinfo
	doins "${S}"/leap-seconds.list

	# Delete man pages installed by man-pages package.
	rm "${ED}"/usr/share/man/man5/tzfile.5* "${ED}"/usr/share/man/man8/{tzselect,zdump,zic}.8 || die
	dodoc CONTRIBUTING README NEWS *.html
}

get_TIMEZONE() {
	local tz src="${EROOT}/etc/timezone"
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

configure_tz_data() {
	# make sure the /etc/localtime file does not get stale #127899
	local tz src="${EROOT}/etc/timezone" etc_lt="${EROOT}/etc/localtime"

	# If it's a symlink, assume the user knows what they're doing and
	# they're managing it themselves. #511474
	if [[ -L "${etc_lt}" ]] ; then
		einfo "Assuming your ${etc_lt} symlink is what you want; skipping update."
		return 0
	fi

	if ! tz=$(get_TIMEZONE) ; then
		einfo "Assuming your empty ${etc_lt} file is what you want; skipping update."
		return 0
	fi
	if [[ "${tz}" == "FOOKABLOIE" ]] ; then
		elog "You do not have TIMEZONE set in ${src}."

		if [[ ! -e "${etc_lt}" ]] ; then
			cp -f "${EROOT}"/usr/share/zoneinfo/Factory "${etc_lt}"
			elog "Setting ${etc_lt} to Factory."
		else
			elog "Skipping auto-update of ${etc_lt}."
		fi
		return 0
	fi

	if [[ ! -e "${EROOT}/usr/share/zoneinfo/${tz}" ]] ; then
		elog "You have an invalid TIMEZONE setting in ${src}"
		elog "Your ${etc_lt} has been reset to Factory; enjoy!"
		tz="Factory"
	fi
	einfo "Updating ${etc_lt} with ${EROOT}/usr/share/zoneinfo/${tz}"
	cp -f "${EROOT}/usr/share/zoneinfo/${tz}" "${etc_lt}"
}

pkg_config() {
	configure_tz_data
}

pkg_postinst() {
	configure_tz_data
}
