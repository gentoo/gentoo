# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Creates a version constraint of supported Rubies,suitable for a gemspec file"
HOMEPAGE="https://github.com/e2/ruby_dep"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm"
IUSE=""
