# Copyright 2013-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 eapi9-ver systemd toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"

# Run from a kernel git repo to generate a tarball for version x.y:
# PV=x.y
# git archive --prefix=cpupower-${PV}/ v{PV} Makefile tools/power/cpupower |
# xz > /tmp/cpupower-${PV}.tar.xz

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="nls"

# File collision w/ headers of the deprecated cpufrequtils
RDEPEND="sys-apps/pciutils"
DEPEND="${RDEPEND}
	virtual/os-headers
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/cpupower-5.4-cflags.patch"
)

src_configure() {
	export bindir="${EPREFIX}/usr/bin"
	export sbindir="${EPREFIX}/usr/sbin"
	export mandir="${EPREFIX}/usr/share/man"
	export libdir="${EPREFIX}/usr/$(get_libdir)"
	export libexecdir="${EPREFIX}/usr/libexec"
	export unitdir="$(systemd_get_systemunitdir)"
	export includedir="${EPREFIX}/usr/include"
	export localedir="${EPREFIX}/usr/share/locale"
	export docdir="${EPREFIX}/usr/share/doc/${PF}"
	export confdir="${EPREFIX}/etc"
	export bash_completion_dir="$(get_bashcompdir)"
	export V=1
	export NLS=$(usex nls true false)
}

src_compile() {
	cd tools/power/cpupower || die
	myemakeargs=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	cd tools/power/cpupower || die
	emake "${myemakeargs[@]}" DESTDIR="${D}" install
	doheader lib/cpupower.h
	einstalldocs

	newconfd "${FILESDIR}"/conf.d-r2 cpupower
	newinitd "${FILESDIR}"/init.d-r4 cpupower
}

pkg_postinst() {
	if ver_replacing -lt 6.16; then
		ewarn "Starting with cpupower-1.16, an upstream systemd unit is provided."
		ewarn "See cpupower.service and /etc/cpupower-service.conf."
		ewarn "Settings must be migrated manually."
	fi
}
