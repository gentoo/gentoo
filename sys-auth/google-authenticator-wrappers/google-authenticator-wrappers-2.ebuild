# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Set of scripts to manage google-auth setup on Gentoo Infra"
HOMEPAGE="https://github.com/projg2/google-authenticator-wrappers"
SRC_URI="https://github.com/projg2/google-authenticator-wrappers/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-auth/google-authenticator"
