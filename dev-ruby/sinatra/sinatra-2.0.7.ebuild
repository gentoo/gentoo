# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST="test:core"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="sinatra.gemspec"

inherit ruby-fakegem

DESCRIPTION="A DSL for quickly creating web applications in Ruby with minimal effort"
HOMEPAGE="http://www.sinatrarb.com/"
SRC_URI="https://github.com/sinatra/sinatra/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/mustermann:1
	dev-ruby/rack:2.0
	~dev-ruby/rack-protection-${PV}
	dev-ruby/tilt:2"
ruby_add_bdepend "test? ( >=dev-ruby/rack-test-0.5.6 dev-ruby/erubis dev-ruby/builder dev-ruby/activesupport )"
ruby_add_bdepend "doc? ( dev-ruby/yard )"
