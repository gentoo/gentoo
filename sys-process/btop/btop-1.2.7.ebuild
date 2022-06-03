# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A monitor of resources"
HOMEPAGE="https://github.com/aristocratos/btop"
SRC_URI="https://github.com/aristocratos/btop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# btop installs README.md to /usr/share/btop by default
	sed -i '/^.*cp -p README.md.*$/d' Makefile || die
}

src_compile() {
	# Disable btop optimization flags, since we have our flags in CXXFLAGS
	emake OPTFLAGS=""
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		install

	dodoc README.md CHANGELOG.md
}
