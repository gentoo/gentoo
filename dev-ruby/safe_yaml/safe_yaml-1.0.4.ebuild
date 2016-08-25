# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Parse YAML safely, alternative implementation of YAML.load"
HOMEPAGE="https://dtao.github.com/safe_yaml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/hashie
	dev-ruby/heredoc_unindent
	dev-ruby/rspec:2 )"

each_ruby_test() {
	# Run specs with monkeypatch
	${RUBY} -S rspec-2 --tag ~libraries || die

	# Running specs without monkeypatch
	${RUBY} -S rspec-2 --tag libraries || die
}
