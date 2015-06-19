# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rdtool/rdtool-0.6.38.ebuild,v 1.11 2014/11/11 10:46:47 mrueg Exp $

EAPI=4
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="HISTORY README.*"

inherit elisp-common ruby-fakegem

DESCRIPTION="A multipurpose documentation format for Ruby"
HOMEPAGE="https://github.com/uwabami/rdtool"

LICENSE="Ruby GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="emacs"

RDEPEND="${RDEPEND} emacs? ( virtual/emacs )"

SITEFILE=50${PN}-gentoo.el

all_ruby_install() {
	all_fakegem_install

	if use emacs ; then
		elisp-install ${PN} utils/rd-mode.el
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
