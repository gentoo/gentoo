# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit flag-o-matic python-r1 toolchain-funcs udev

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git https://kernel.googlesource.com/pub/scm/linux/kernel/git/colyli/bcache-tools.git"
else
	SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"
fi

DESCRIPTION="Tools for bcache"
HOMEPAGE="https://bcache.evilpiepirate.org/ https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/"

SLOT="0"
LICENSE="GPL-2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/util-linux
	virtual/udev
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-e '/.*INSTALL.*share\/man/d' \
		-e '/.*INSTALL.*bcache-status/d' \
		-i Makefile || die

	append-lfs-flags
}

src_install() {
	local udevdir="$(get_udevdir)"

	local mydirs=(
		sbin
		"${udevdir}/rules.d"
		/usr/share/initramfs-tools/hooks/bcache
		/usr/lib/initcpio/install/bcache
	)
	dodir "${mydirs[@]}"

	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}" \
		UDEVLIBDIR="${udevdir}" \
		DRACUTLIBDIR="/usr/lib/dracut" \
		install

	python_foreach_impl python_doscript bcache-status

	doman *.8

	dodoc README
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
