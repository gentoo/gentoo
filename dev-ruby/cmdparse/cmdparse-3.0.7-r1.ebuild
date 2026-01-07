# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Advanced command line parser supporting commands"
HOMEPAGE="https://cmdparse.gettalong.org/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~ppc64 ~x86"
