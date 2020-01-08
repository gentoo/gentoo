# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="DeepCopy"

DESCRIPTION="Create deep copies (clones) of your objects"
HOMEPAGE="https://github.com/myclabs/DeepCopy"
SRC_URI="https://github.com/myclabs/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.1:*"

src_install() {
	insinto /usr/share/php/myclabs
	doins -r src/*
	insinto /usr/share/php/myclabs/DeepCopy
	doins "${FILESDIR}/autoload.php"
}
