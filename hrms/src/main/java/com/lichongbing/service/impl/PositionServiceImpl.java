package com.lichongbing.service.impl;

import com.lichongbing.dao.PositionDao;
import com.lichongbing.domain.Position;
import com.lichongbing.service.PositionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
@Service("positionService")
public class PositionServiceImpl implements PositionService {
    @Autowired
    private PositionDao positionDao;

    public List<Position> findPositions(Map<String, Object> map) {

        return positionDao.findPositions(map);
    }

    public Integer getCount(Map<String, Object> map) {

        return positionDao.getCount(map);
    }

    public Integer addPosition(Position position) {

        return positionDao.addPosition(position);
    }

    public Integer updatePosition(Position position) {

        return positionDao.updatePosition(position);
    }

    public Integer deletePosition(Integer id) {
        Integer flag = null;
        try {
            flag = positionDao.deletePosition(id);
        } catch (Exception e) {
            throw new RuntimeException();
        }

        return flag;
    }
}
