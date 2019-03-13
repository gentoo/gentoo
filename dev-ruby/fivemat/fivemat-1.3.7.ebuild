# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# Package does not contain tests
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="MiniTest/RSpec/Cucumber formatter that gives each test file its own line of dots"
HOMEPAGE="https://github.com/tpope/fivemat"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
