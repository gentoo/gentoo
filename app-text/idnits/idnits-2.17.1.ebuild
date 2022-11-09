# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool to check internet-drafts (IDs) for submission nits"
HOMEPAGE="https://www.ietf.org/tools/idnits/"
SRC_URI="https://github.com/ietf-tools/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"

SLOT="0"

KEYWORDS="amd64 x86"

RDEPEND="
	app-shells/bash
	sys-apps/coreutils
	virtual/awk
"

src_install() {
	dobin idnits
	dodoc about changelog todo
}
