# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="ruby on rails is a web-application and persistence framework"
HOMEPAGE="https://rubyonrails.org"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

ruby_add_rdepend "
	~dev-ruby/actioncable-${PV}
	~dev-ruby/actionmailbox-${PV}
	~dev-ruby/actionmailer-${PV}
	~dev-ruby/actionpack-${PV}
	~dev-ruby/actiontext-${PV}
	~dev-ruby/actionview-${PV}
	~dev-ruby/activejob-${PV}
	~dev-ruby/activemodel-${PV}
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activestorage-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/bundler-1.15.0:*
	~dev-ruby/railties-${PV}
"
