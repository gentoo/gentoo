# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="DeepCopy"

DESCRIPTION="Create deep copies (clones) of your objects"
HOMEPAGE="https://github.com/myclabs/DeepCopy"
SRC_URI="https://github.com/myclabs/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.1:*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	phpab \
		--output src/${MY_PN}/autoload.php \
		--template fedora2 \
		--basedir src/${MY_PN} \
		src || die
}

src_install() {
	insinto /usr/share/php/myclabs
	doins -r src/*

	einstalldocs
}
