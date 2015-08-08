try:
    import asyncio
    from asyncio.test_utils import run_once as _run_once

    def run_once():
        return _run_once(asyncio.get_event_loop())

except ImportError as e:
    try:
        import trollius as asyncio
    except ImportError:
        asyncio = None

    def run_once():
        '''
        copied from asyncio.testutils because trollius has no
        "testutils"
        '''
        # in Twisted, this method is a no-op
        if asyncio is None:
            return

        # just like modern asyncio.testutils.run_once does it...
        loop = asyncio.get_event_loop()
        loop.stop()
        loop.run_forever()
        asyncio.gather(*asyncio.Task.all_tasks())


try:
    # XXX fixme hack better way to detect twisted
    # (has to work on py3 where asyncio exists always, though)
    import twisted  # noqa

    def await(_):
        return

except ImportError:
    def await(future):
        asyncio.get_event_loop().run_until_complete(future)
