# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.md"

RUBY_FAKEGEM_GEMSPEC="mail.gemspec"

inherit ruby-fakegem

GITHUB_USER="mikel"

DESCRIPTION="An email handling library"
HOMEPAGE="https://github.com/mikel/mail"
SRC_URI="https://github.com/${GITHUB_USER}/mail/archive/${PV}.tar.gz -> ${P}-git.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"

ruby_add_rdepend "
	dev-ruby/logger
	>=dev-ruby/mini_mime-0.1.1
	dev-ruby/net-imap
	dev-ruby/net-pop
	dev-ruby/net-smtp
"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undle/d' -e '6d' Rakefile || die "Unable to remove Bundler code."

	sed -i -e '/benchmark/I s:^:#:' spec/spec_helper.rb || die

	sed -e "s:_relative ': './:" \
		-i ${RUBY_FAKEGEM_GEMSPEC}
}
