# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="pass extension that provides an easy flow for updating passwords"
HOMEPAGE="https://github.com/roddhjav/pass-update"
SRC_URI="https://github.com/roddhjav/pass-update/releases/download/v${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND=">=app-admin/pass-1.7"
