# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Installs Ruby, JRuby, Rubinius, MagLev or MRuby"
HOMEPAGE="https://github.com/postmodern/ruby-install"
SRC_URI="https://github.com/postmodern/ruby-install/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-shells/bash-3.0"
RDEPEND="${DEPEND}
	|| ( >net-misc/wget-1.12 net-misc/curl )
	dev-libs/openssl
	app-arch/tar
	app-arch/bzip2
	sys-devel/patch
	|| ( >=sys-devel/gcc-4.2 sys-devel/clang )"
