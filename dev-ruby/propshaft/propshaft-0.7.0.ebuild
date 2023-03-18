# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="propshaft.gemspec"

inherit ruby-fakegem

DESCRIPTION="Deliver assets for Rails"
HOMEPAGE="https://github.com/rails/propshaft"
SRC_URI="https://github.com/rails/propshaft/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"

IUSE=""

ruby_add_rdepend "
	>=dev-ruby/actionpack-7.0.0:*
	>=dev-ruby/activesupport-7.0.0:*
	dev-ruby/rack:*
	>=dev-ruby/railties-7.0.0:*
"

ruby_add_bdepend "test? ( >=dev-ruby/rails-7.0.0 )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	sed -i -e '/debug/ s:^:#:' Gemfile || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
