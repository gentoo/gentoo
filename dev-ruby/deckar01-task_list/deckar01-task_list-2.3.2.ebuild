# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Markdown TaskList components"
HOMEPAGE="https://github.com/deckar01/task_list"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/html-pipeline
"

ruby_add_bdepend "test? (
	dev-ruby/commonmarker
	dev-ruby/coffee-script
	dev-ruby/json
	dev-ruby/rack
	dev-ruby/sprockets
)"
