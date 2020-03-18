# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="a ERB template engine for ruby; a simplified fork of Erubis"
HOMEPAGE="https://github.com/jeremyevans/erubi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"
