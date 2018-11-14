# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.md"

RUBY_FAKEGEM_GEMSPEC="mail.gemspec"

inherit ruby-fakegem versionator

GITHUB_USER="mikel"

DESCRIPTION="An email handling library"
HOMEPAGE="https://github.com/mikel/mail"
SRC_URI="https://github.com/${GITHUB_USER}/mail/archive/${PV}.tar.gz -> ${P}-git.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/mini_mime-0.1.1"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undle/d' -e '6d' Rakefile || die "Unable to remove Bundler code."
}
