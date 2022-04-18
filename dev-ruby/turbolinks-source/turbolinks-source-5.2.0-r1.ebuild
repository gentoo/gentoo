# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

# The gem does not contain runnable tests.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Turbolinks JavaScript assets"
HOMEPAGE="https://github.com/rails/turbolinks-source-gem"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE="test"
