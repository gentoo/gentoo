# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# eutils: strip-linguas
inherit eutils systemd toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="nls"

# File collision w/ headers of the deprecated cpufrequtils
RDEPEND="sys-apps/pciutils
	!<sys-apps/linux-misc-apps-3.6-r2
	!sys-power/cpufrequtils"
DEPEND="${RDEPEND}
	virtual/os-headers
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/cflags-strip.patch
)

src_configure() {
	export bindir="${EPREFIX}/usr/bin"
	export sbindir="${EPREFIX}/usr/sbin"
	export mandir="${EPREFIX}/usr/share/man"
	export includedir="${EPREFIX}/usr/include"
	export libdir="${EPREFIX}/usr/$(get_libdir)"
	export localedir="${EPREFIX}/usr/share/locale"
	export docdir="${EPREFIX}/usr/share/doc/${PF}"
	export confdir="${EPREFIX}/etc"
	export V=1
	export NLS=$(usex nls true false)
}

src_compile() {
	myemakeargs=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		VERSION=${PV}
	)

	if [[ -n ${LINGUAS+set} ]]; then
		strip-linguas -i po
		myemakeargs+=( LANGUAGES="${LINGUAS}" )
	fi

	emake "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${myemakeargs[@]}" install
	doheader lib/cpupower.h
	dodoc README ToDo

	newconfd "${FILESDIR}"/conf.d-r2 cpupower
	newinitd "${FILESDIR}"/init.d-r4 cpupower

	systemd_dounit "${FILESDIR}"/cpupower-frequency-set.service
	systemd_install_serviced "${FILESDIR}"/cpupower-frequency-set.service.conf
}
