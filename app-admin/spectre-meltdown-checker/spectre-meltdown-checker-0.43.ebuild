# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/speed47/spectre-meltdown-checker.git"
else
	SRC_URI="https://github.com/speed47/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Spectre & Meltdown vulnerability/mitigation checker for Linux"
HOMEPAGE="https://github.com/speed47/spectre-meltdown-checker"

LICENSE="GPL-3+"
SLOT="0"

src_install() {
	default
	newbin spectre-meltdown-checker.sh spectre-meltdown-checker
}
