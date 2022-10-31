# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

MY_CODE_VER=${PV}
MY_DATA_VER=${PV}
DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="https://www.iana.org/time-zones"
SRC_URI="https://www.iana.org/time-zones/repository/releases/tzdata${MY_DATA_VER}.tar.gz
	https://www.iana.org/time-zones/repository/releases/tzcode${MY_CODE_VER}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls leaps-timezone zic-slim"

DEPEND="nls? ( virtual/libintl )"
RDEPEND="
	${DEPEND}
	!sys-libs/glibc[vanilla(+)]
"

src_unpack() {
	mkdir "${S}" && cd "${S}" || die
	default
}

src_prepare() {
	default

	# check_web contacts validator.w3.org
	sed -i -e 's/check_tables check_web/check_tables/g' \
		Makefile || die "Failed to disable check_web"

	if tc-is-cross-compiler ; then
		cp -pR "${S}" "${S}"-native || die
	fi
}

src_configure() {
	tc-export CC

	# bug #471102
	append-lfs-flags

	if use elibc_Darwin ; then
		# bug #138251
		append-cppflags -DSTD_INSPIRED
	fi

	append-cppflags -DHAVE_GETTEXT=$(usex nls 1 0) -DTZ_DOMAIN='\"libc\"'

	# Upstream default is 'slim', but it breaks quite a few programs
	# that parse /etc/localtime directly: bug #747538.
	append-cppflags -DZIC_BLOAT_DEFAULT='\"'$(usex zic-slim slim fat)'\"'

	LDLIBS=""
	if use nls ; then
		# See if an external libintl is available. bug #154181, bug #578424
		local c="${T}/test"
		echo 'main(){}' > "${c}.c" || die
		if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} "${c}.c" -o "${c}" -lintl 2>/dev/null ; then
			LDLIBS+=" -lintl"
		fi
	fi
}

_emake() {
	emake \
		REDO=$(usex leaps-timezone posix_right posix_only) \
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
	# VALIDATE_ENV is used for extended/web based tests. Punt on them.
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
}

configure_tz_data() {
	# Make sure the /etc/localtime file does not get stale, bug #127899
	local tz src="${EROOT}/etc/timezone" etc_lt="${EROOT}/etc/localtime"

	# If it's a symlink, assume the user knows what they're doing and
	# they're managing it themselves, bug #511474
	if [[ -L "${etc_lt}" ]] ; then
		einfo "Assuming your ${etc_lt} symlink is what you want; skipping update."
		return 0
	fi

	if ! tz=$(get_TIMEZONE) ; then
		einfo "Assuming your empty ${src} file is what you want; skipping update."
		return 0
	fi

	if [[ "${tz}" == "FOOKABLOIE" ]] ; then
		einfo "You do not have a timezone set in ${src}; skipping update."
		return 0
	fi

	local tzpath="${EROOT}/usr/share/zoneinfo/${tz}"

	if [[ ! -e ${tzpath} ]]; then
		ewarn "The timezone specified in ${src} is not valid!"
		return 1
	fi

	if [[ -f ${etc_lt} ]]; then
		# If a regular file already exists, copy over it.
		ewarn "Found a regular file at ${etc_lt}."
		ewarn "Some software may expect a symlink instead."
		ewarn "You may convert it to a symlink by removing the file and running:"
		ewarn "  emerge --config sys-libs/timezone-data"
		einfo "Copying ${tzpath} to ${etc_lt}."
		cp -f "${tzpath}" "${etc_lt}"
	else
		# Otherwise, create a symlink and remove the timezone file.
		tzpath="../usr/share/zoneinfo/${tz}"
		einfo "Linking ${tzpath} at ${etc_lt}."
		if ln -snf "${tzpath}" "${etc_lt}"; then
			einfo "Removing ${src}."
			rm -f "${src}"
		fi
	fi
}

pkg_config() {
	configure_tz_data
}

pkg_postinst() {
	configure_tz_data
}
