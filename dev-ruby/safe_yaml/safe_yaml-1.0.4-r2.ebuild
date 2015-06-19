# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/safe_yaml/safe_yaml-1.0.4-r2.ebuild,v 1.1 2015/05/24 06:47:21 graaff Exp $

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Parse YAML safely, without that pesky arbitrary object deserialization vulnerability"
HOMEPAGE="https://dtao.github.com/safe_yaml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/hashie
	dev-ruby/heredoc_unindent
	dev-ruby/rspec:3 )"

each_ruby_test() {
	# Run specs with monkeypatch
	${RUBY} -S rspec-3 --tag ~libraries || die

	# Running specs without monkeypatch
	${RUBY} -S rspec-3 --tag libraries || die
}
