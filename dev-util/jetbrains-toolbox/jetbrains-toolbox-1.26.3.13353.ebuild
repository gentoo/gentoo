# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An app to manage JetBrains IDEs with ease."
HOMEPAGE="https://www.jetbrains.com/toolbox-app"
SRC_URI="https://download.jetbrains.com/toolbox/${P}.tar.gz"
S="${WORKDIR}"
LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1 codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0 GPL-2 GPL-2-with-classpath-exception ISC JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT MPL-1.0 MPL-1.1 OFL ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
QA_PRESTRIPPED="/usr/bin/${PN}"
DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
dobin "${S}/${P}/${PN}"
}
