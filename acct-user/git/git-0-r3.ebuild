# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Git repository hosting user"

IUSE="+git gitea gitolite forgejo"
REQUIRED_USE="^^ ( git gitea gitolite forgejo )"

ACCT_USER_ID=196
ACCT_USER_HOME_PERMS=750
ACCT_USER_SHELL=/bin/sh
ACCT_USER_GROUPS=( git )

acct-user_add_deps

pkg_setup() {
	if use git; then
		ACCT_USER_HOME=/var/lib/git
	elif use gitea; then
		ACCT_USER_HOME=/var/lib/gitea
	elif use gitolite; then
		ACCT_USER_HOME=/var/lib/gitolite
	elif use forgejo; then
		ACCT_USER_HOME=/var/lib/forgejo
	else
		die "Incorrect USE flag combination"
	fi
}
