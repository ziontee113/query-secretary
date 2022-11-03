describe("just testing the describe block", function()
    before_each(function()
        print "before_each run"
    end)
    after_each(function()
        print "after_each run"
    end)

    it("just testing", function()
        assert.equals(1, 1)
    end)

    it("just testing 2", function()
        assert.equals(2, 2)
    end)
end)
