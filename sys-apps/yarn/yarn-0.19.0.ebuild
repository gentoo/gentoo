# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, reliable, and secure node dependency management"
HOMEPAGE="https://yarnpkg.com"
SRC_URI="https://github.com/yarnpkg/yarn/releases/download/v${PV}/yarn-v${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!dev-util/cmdtest
	net-libs/nodejs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/dist"

src_install() {
	local install_dir="/usr/$(get_libdir)/node_modules/yarn"
	insinto "${install_dir}"
	doins -r .
	dosym "../$(get_libdir)/node_modules/yarn/bin/yarn.js" "/usr/bin/yarn"
	fperms a+x "${install_dir}/bin/yarn.js"
}
