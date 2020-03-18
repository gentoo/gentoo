# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

# The gem does not contain runnable tests.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Makes following links in your web application faster"
HOMEPAGE="https://github.com/rails/turbolinks"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
