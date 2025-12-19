# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic unpacker

DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="https://www.iana.org/time-zones"
SRC_URI="
	https://data.iana.org/time-zones/releases/tzdb-${PV}.tar.lz
"
S="${WORKDIR}"/tzdb-${PV}

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls leaps-timezone zic-slim"

DEPEND="nls? ( virtual/libintl )"
RDEPEND="
	${DEPEND}
	!sys-libs/glibc[vanilla(+)]
"
BDEPEND="$(unpacker_src_uri_depends)"

src_prepare() {
	default

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

	# Upstream default is 'slim', but it breaks quite a few programs,
	# that parse /etc/localtime directly: bug #747538.
	append-cppflags -DZIC_BLOAT_DEFAULT='\"'$(usex zic-slim slim fat)'\"'

	LDLIBS=""
	if use nls ; then
		# See if an external libintl is available. bug #154181, bug #578424
		local c="${T}/test"
		echo 'int main(){}' > "${c}.c" || die
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
	tc-export AR CC RANLIB

	_emake \
		CFLAGS="${CFLAGS} -std=gnu99 ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="${LDLIBS}"

	if tc-is-cross-compiler ; then
		_emake -C "${S}"-native \
			AR="$(tc-getBUILD_AR)" \
			CC="$(tc-getBUILD_CC)" \
			RANLIB="$(tc-getBUILD_RANLIB)" \
			CFLAGS="${BUILD_CFLAGS} ${BUILD_CPPFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}" \
			LDLIBS="${LDLIBS}" \
			zic
	fi
}

src_test() {
	# CURL is used for extended/web based tests. Punt on them.
	emake check CURL=:
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

configure_tz_data() {
	# Make sure the /etc/localtime file does not get stale, bug #127899
	local tz src="${EROOT}/etc/timezone" etc_lt="${EROOT}/etc/localtime"

	# If it's a symlink, assume the user knows what they're doing and
	# they're managing it themselves, bug #511474
	if [[ -L "${etc_lt}" ]] ; then
		einfo "Skipping update: ${etc_lt} is a symlink."
		if [[ -e ${src} ]]; then
			einfo "Removing ${src}."
			rm "${src}"
		fi
		return 0
	fi

	if [[ ! -e ${src} ]] ; then
		einfo "Skipping update: ${src} does not exist."
		return 0
	fi

	tz=$(sed -e 's:#.*::' -e 's:[[:space:]]*::g' -e '/^$/d' "${src}")

	if [[ -z ${tz} ]]; then
		einfo "Skipping update: ${src} is empty."
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
		ewarn "Convert it to a symlink by removing the file and running:"
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
