Gentoo ebuild repository rsync-to-git mirror
============================================

*This repository is updated automatically. __Please do not push anything
to it or merge pull requests.__ The script will automatically remove any
added commits on the next update but this can cause __significant
issues__ to users who pulled before the update.*


Introduction
------------

This repository provides automatically updated git mirror of the Gentoo
ebuild repository. The mirror is created from rsync and contains all
the necessary metadata and caches, therefore it is completely suitable
for syncing Gentoo installs. It also serves as a common point for
submitting pull requests with ebuild fixes.


Syncing from the git mirror
---------------------------

A package manager with git repository support can be used to sync using
the mirror. The current git version of Portage (-9999) supports git
sync, and it will be available in the 2.2.16 release.

The `repos.conf` entry for git sync may look like the following:

    [gentoo]
	location = /var/db/repos/gentoo
	sync-type = git
	sync-uri = https://github.com/gentoo/gentoo-portage-rsync-mirror
	auto-sync = true

Please note that if you use existing repository location, you *need to
remove the existing repository first*.


Maintenance notes
-----------------

Please note that unlike rsync, git does not clobber modified files. This
means that if you perform any local (uncommitted) changes, git will
refuse to update the repository. In order to restore working copy to
the vanilla state (revert all changes, remove new files):

    $ cd /var/db/repos/gentoo
	$ git reset --hard
	$ git clean -df

If you commit inside the repository, the successive syncs will involve
creating merge commits. Your package manager will require you to resolve
any arising merge conflicts manually. If you'd like to remove all added
commits (and other changes) and restore the repository to vanilla state:

    $ cd /var/db/repos/gentoo
	$ git reset --hard origin/master
	$ git clean -df


Cloning the repository
----------------------

If your package manager does not support git natively, or you'd like to
work with ebuilds, you can clone the repository using the following
command:

    $ git clone --depth 1 \
		https://github.com/gentoo/gentoo-portage-rsync-mirror \
		/var/db/repos/gentoo

While `--depth 1` is not strictly necessary, it is recommended due to
humongous size of the repository.

Afterwards, the repository can be updated using:

    $ cd /var/db/repos/gentoo
	$ git pull


Using pull requests
-------------------

The repository provides a common point for collecting contributions to
Gentoo. If you'd like to submit ebuild fixes or a new ebuild that you'd
be willing to [proxy-maintain][1], just fork the repository, commit it
and submit a pull request.

Please note a few things though:

1. Do not submit new ebuilds unless you or someone else is willing to
   maintain them afterwards.

2. Please do not submit changes that were already submitted via other
   media and rejected.

3. Please note that your changes will be reviewed and you may be asked
   to fix issues before the Pull Request is accepted. Please watch for
   comments and respond to them.

4. Avoid mixing unrelated changes in one Pull Request. Create branches
   for unrelated (non-successive) commits in your fork.

5. Always run `repoman full` on your ebuild directory before committing
   and review the output.

6. Please do not add/update ChangeLogs. Since we need to move your
   changes need to CVS manually, we will create/update them for you.
   And they often cause merge conflicts.

7. Try to provide useful information in commit messages but don't worry
   about them too much. Since the changes will be re-committed in CVS
   manually, we will end up updating the commit message anyway.

8. Please note that the Pull Requests won't be merged directly into
   the repository but re-committed in CVS. GitHub will likely report
   that your Pull Request has been refused and you will have to remove
   your commits to pull. That's why it is a good idea to perform changes
   in separate branches and remove them afterwards.

[1]:https://wiki.gentoo.org/wiki/Project:Proxy_Maintainers


For Gentoo developers
---------------------

Developers, thank you for your interest in the git mirror. If you'd like
to help us handling Pull Requests, please note the following:

1. Do not *ever* push anything to the mirror or use the *merge* feature
   provided by GitHub. Instead, copy files over to CVS, update
   the ChangeLog and commit as usual.

2. Please respect other developers and do not commit something you
   wouldn't normally commit. If necessary, contact the maintainer,
   open a bug or ask user to open one.

3. Please try to keep others informed on your actions related to a Pull
   Request. Preferably use Pull Request and commit inline comments to
   review. If you perform any actions that do not result in explicit
   notice in the Pull Request (open bug, contact submitter directly),
   please leave an appropriate note on the Pull Request.

4. Please keep up to the Gentoo QA standards. If in doubt, ask
   the submitter. Perform the final commit using `repoman commit`.

If you'd like to review Pull Requests regularly, please consider joining
the [git mirror][2] project team.

[2]:https://wiki.gentoo.org/wiki/Project:Git_mirror
