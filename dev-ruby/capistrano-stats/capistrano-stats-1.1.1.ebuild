# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="tasks"

inherit ruby-fakegem

DESCRIPTION="Official metrics to help the development direction of Capistrano"
HOMEPAGE="http://metrics.capistranorb.com/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""
