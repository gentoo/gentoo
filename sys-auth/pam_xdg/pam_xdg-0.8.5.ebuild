# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam

DESCRIPTION="PAM module that manages XDG Base Directories"
HOMEPAGE="https://www.sdaoden.eu/code.html"
SRC_URI="https://ftp.sdaoden.eu/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

src_install() {
	dopammod pam_xdg.so
	doman pam_xdg.8
}
