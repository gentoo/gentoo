# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Modernizr JS assets for use in Sprockets or the Rails 3 asset pipeline"
HOMEPAGE="https://github.com/josh/ruby-modernizr"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
