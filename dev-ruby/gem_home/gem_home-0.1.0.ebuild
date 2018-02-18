# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool for changing your GEM_HOME."
HOMEPAGE="https://github.com/postmodern/gem_home"
SRC_URI="https://github.com/postmodern/gem_home/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( >=app-shells/bash-3.0 app-shells/zsh )"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${D}/usr/local" install

	dodir "/etc/profile.d"
	insinto "/etc/profile.d"
	newins "${FILESDIR}/systemwide.sh" "gem_home.sh"
}
