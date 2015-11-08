# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Hash extension to make working with nested hashes easier and less error-prone"
HOMEPAGE="https://github.com/liufengyun/hashdiff"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""
