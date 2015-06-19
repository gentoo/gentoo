# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PHP_Shell/PEAR-PHP_Shell-0.3.2.ebuild,v 1.1 2015/01/14 18:04:14 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="A shell for PHP with history and tab-completion"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="auto-completion"

RDEPEND=">=dev-lang/php-5.3[tokenizer]
	auto-completion? ( dev-lang/php[readline] )"

src_prepare() {
	# Fill in Gentoo values for placeholders
	sed -i  -e "s~@php_bin@~${EPREFIX}/usr/bin/php~" \
		-e "s~@php_dir@~${EPREFIX}/usr/share/php/scripts~" "${S}/scripts/php-shell.sh" || die
	# Fix version value.  Upstream forgot to update in code but made a release anyway
	sed -i "s/$version = '0.3.1'/$version = '0.3.2'/" "${S}/PHP/Shell.php" || die
}

src_install() {
	php-pear-r1_src_install
	dobin scripts/php-shell.sh
	dosym php-shell.sh /usr/bin/php-shell
}
