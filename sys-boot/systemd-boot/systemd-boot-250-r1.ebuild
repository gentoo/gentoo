# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual package to depend on sys-apps/systemd-utils"
HOMEPAGE="https://systemd.io/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="sys-apps/systemd-utils[boot]"
