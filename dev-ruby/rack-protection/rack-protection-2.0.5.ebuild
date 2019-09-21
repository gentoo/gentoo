# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# There are no specs in the gem and the source cannot be downloaded separately.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem eapi7-ver

DESCRIPTION="This gem protects against typical web attacks"
HOMEPAGE="https://github.com/rkh/rack-protection"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/rack:*"

# ruby_add_bdepend "test? ( dev-ruby/rack-test )"
