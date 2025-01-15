# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools verify-sig

MY_COMMIT="da14466ce09afa3b39adb2b324be20084b776eb7"
https://github.com/lxc/lxc-templates/archive/da14466ce09afa3b39adb2b324be20084b776eb7.zip
DESCRIPTION="Old style template scripts for LXC"
HOMEPAGE="https://linuxcontainers.org/ https://github.com/lxc/lxc-templates"
SRC_URI="https://github.com/lxc/lxc-templates/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND=">=app-containers/lxc-3.0"
DEPEND="${RDEPEND}"

DOCS=()

S="${WORKDIR}/lxc-templates-${MY_COMMIT}"

src_prepare() {
	default
	eautoreconf
}
