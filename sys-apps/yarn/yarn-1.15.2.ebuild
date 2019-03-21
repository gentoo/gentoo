# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-v${PV}"

DESCRIPTION="Fast, reliable, and secure node dependency management"
HOMEPAGE="https://yarnpkg.com"
SRC_URI="https://github.com/yarnpkg/yarn/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!dev-util/cmdtest
	net-libs/nodejs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i 's/"installationMethod": "tar"/"installationMethod": "portage"/g' "${S}/package.json" || die
}

src_install() {
	local install_dir="/usr/$(get_libdir)/node_modules/yarn" path shebang
	insinto "${install_dir}"
	doins -r .
	dosym "../$(get_libdir)/node_modules/yarn/bin/yarn.js" "/usr/bin/yarn"

	while read -r -d '' path; do
		read -r shebang < "${ED}${path}" || die
		[[ "${shebang}" == \#\!* ]] || continue
		fperms +x "${path}"
	done < <(find "${ED}" -type f -printf '/%P\0' || die)
}
