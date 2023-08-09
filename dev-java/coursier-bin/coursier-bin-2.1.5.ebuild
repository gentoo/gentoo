# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

get_orig_coursier_pv() {
	local orig_pv=$(ver_rs 3 -)
	orig_pv=${orig_pv/rc/RC}
	orig_pv=${orig_pv/pre/M}
	echo "${orig_pv}"
}

DESCRIPTION="Java/Scala artifact fetching, bundling and deploying"
HOMEPAGE="https://get-coursier.io/"
SRC_URI="https://github.com/coursier/coursier/releases/download/v$(get_orig_coursier_pv)/cs-x86_64-pc-linux.gz -> ${P}.gz"

KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-8"

QA_FLAGS_IGNORED="usr/bin/coursier"
QA_TEXTRELS="usr/bin/coursier"

src_install() {
	newbin "${P}" coursier
}
