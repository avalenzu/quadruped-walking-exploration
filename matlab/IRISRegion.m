classdef IRISRegion
  properties
    A
    b
    point
    normal
  end

  methods
    function obj = IRISRegion(A, b, point, normal)
      obj.A = A;
      obj.b = b;
      obj.point = point;
      obj.normal = normal;
    end

    function msg = to_iris_region_t(obj)
      msg = drc.iris_region_t();
      msg.lin_con = drc.lin_con_t();
      msg.lin_con.m = size(obj.A, 1);
      msg.lin_con.n = size(obj.A, 2);
      msg.lin_con.m_times_n = msg.lin_con.m*msg.lin_con.n;
      msg.lin_con.A = reshape(obj.A, [], 1);
      msg.lin_con.b = obj.b;
      msg.point = obj.point;
      msg.normal = obj.normal;
    end

    function draw_lcmgl(obj, lcmgl)
      % Draw the xy projection of the x,y,yaw region
      V = iris.thirdParty.polytopes.lcon2vert(obj.A, obj.b);
      V = V';
      V = V(1:2, convhull(V(1,:), V(2,:)));

%       lcmgl.glColor3f(1,204/255,0)
      lcmgl.glColor3f(0.7, 0.7, 0.7)
      lcmgl.glLineWidth(3)
      lcmgl.glBegin(lcmgl.LCMGL_LINE_LOOP)
      for j = 1:size(V, 2)-1
        lcmgl.glVertex3f(V(1,j), V(2,j), obj.point(3)+0.01);
        lcmgl.glVertex3f(V(1,j+1), V(2,j+1), obj.point(3)+0.01);
      end
%       lcmgl.glVertex3f(V(1,end), V(2,end), obj.point(3)+0.01);
%       lcmgl.glVertex3f(V(1,1), V(2,1), obj.point(3)+0.01);
      lcmgl.glEnd();
%       lcmgl.sphere(obj.point, 0.05, 20, 20);
    end

  end

  methods (Static=true)
    function obj = from_iris_region_t(msg)
      A = reshape(msg.lin_con.A, msg.lin_con.m, msg.lin_con.n);
      b = msg.lin_con.b;
      point = msg.point;
      normal = msg.normal;
      obj = IRISRegion(A, b, point, normal);
    end
  end
end

