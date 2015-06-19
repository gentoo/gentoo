# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/safe_yaml/safe_yaml-1.0.4-r1.ebuild,v 1.1 2015/02/04 20:00:55 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

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
	dev-ruby/rspec:2 )"

each_ruby_test() {
	# Run specs with monkeypatch
	${RUBY} -S rspec --tag ~libraries || die

	# Running specs without monkeypatch
	${RUBY} -S rspec --tag libraries || die
}
