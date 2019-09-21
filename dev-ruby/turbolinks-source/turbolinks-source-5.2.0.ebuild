# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

# The gem does not contain runnable tests.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Turbolinks JavaScript assets"
HOMEPAGE="https://github.com/rails/turbolinks-source-gem"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE="test"
